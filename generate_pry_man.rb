class GeneratePryMan
  require 'ronn'
  require 'pry'
  require 'erb'

  def initialize(opts={})
    @basename = opts.fetch(:basename, "./templates/pry.1")
    @html_template = ERB.new(File.read(@basename + ".erb"), 0, "%<>")

    @man_sections = opts.fetch(:man_sections, get_man_sections)
    @ronn_file_obj = opts.fetch(:ronn_file, File.new(@basename + ".ronn", "w"))
    @html_file     = opts.fetch(:html_file, File.new(@basename + ".html", "w"))
    @roff_file     = opts.fetch(:roff_file, File.new(@basename + ".roff", "w"))
  end

  def ronn_to_roff
    ronn_document = Ronn::Document.new(ronn_file.path)
    roff_file.write(ronn_document.to_roff)
  ensure
    roff_file.close
  end

  def ronn_to_html
    ronn_document = Ronn::Document.new(ronn_file.path)
    html_file.write(ronn_document.to_html)
  ensure
    html_file.close
  end

  def generate_all
    ronn_to_roff
    ronn_to_html
  ensure
    ronn_file.close
  end

  protected

  def ronn_file
    @ronn_file ||= generate_ronn
  end

  def roff_file
    @roff_file
  end

  def html_file
    @html_file
  end

  def get_man_sections
    @man_sections ||= {}

    Dir.glob("./templates/man_sections/*.md").each do |s|
      @man_sections[File.basename(s, '.md').to_sym] = File.read(s)
    end

    @man_sections[:pry_commands] = get_pry_commands_string.join("\n\n")
    @man_sections
  end

  def basename
    @basename
  end

  def get_pry_commands_string
    Pry.commands.map do |(command_name, command)|
      "* `#{command_name}`:\n#{command.description}\n\t#{command.banner}"
    end
  end

  def generate_ronn
    @man_sections
    @ronn_file_obj.puts(@html_template.result(binding))
    @ronn_file_obj.rewind
    @ronn_file_obj
  end
end

if __FILE__ == $0
  gpm = GeneratePryMan.new
  gpm.generate_all
end
