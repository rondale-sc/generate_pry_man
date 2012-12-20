class GeneratePryMan
  require 'ronn'
  require 'pry'
  require 'erb'

  attr_accessor :ronn_file, :basename

  def initialize(opts={})
    @basename = opts.fetch(:basename, "./templates/pry.1")
    @html_template = ERB.new(File.read(@basename + ".erb"), 0, "%<>")
  end

  def get_pry_commands_string
    Pry.commands.map do |(command_name, command)|
      "* `#{command_name}`:\n#{command.description}\n\t#{command.banner}"
    end
  end

  def ronn_file
    @ronn_file ||= generate_ronn
  end

  def generate_ronn
    @pry_commands = get_pry_commands_string.join("\n\n")
    file =File.new("#{basename}.ronn", "w")
    file.puts(@html_template.result(binding))
    file
  end

  def ronn_to_roff
    ronn_document = Ronn::Document.new(ronn_file.path)
    File.open("#{basename}.roff", "w") {|f| f.write(ronn_document.to_roff) }
  end

  def ronn_to_html
    ronn_document = Ronn::Document.new(ronn_file.path)
    File.open("#{basename}.html", "w") {|f| f.write(ronn_document.to_html) }
  end

  def generate_all
    ronn_to_roff
    ronn_to_html
  ensure
    ronn_file.close
  end
end

gpm = GeneratePryMan.new
gpm.generate_all

