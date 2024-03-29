###Basic Usage


    $ pry
    [1] pry(main)>4 + 5
    => 9
    [2] pry(main)> def hello_world
    [2] pry(main)*   puts "Hello, World!"
    [2] pry(main)* end  
    => nil
    [3] pry(main)> hello_world
    Hello, World!
    => nil

###Command Line Interaction


Prefix any command you want your shell to execute with a period and pry will return the results from your shell.

    [1] pry(main)> .date
    Fri Nov 11 09:52:07 EST 2011

On the command line enter `shell-mode` to incorporate the current working directory into the Pry prompt.

    pry(main)> shell-mode
    pry main:/Users/john/ruby/projects/pry $ .cd ..
    pry main:/Users/john/ruby/projects $ .cd ~
    pry main:/Users/john $ .pwd
    /Users/john
    pry main:/Users/john $ shell-mode
    pry(main)>

###State Navigation


The cd command is used to move into a new object (or scope) inside a Pry session.  When inside the new scope it becomes the self for the session and all commands and methods will operate on this new self.

    pry(main)> self
    => main
    pry(main)> cd Pry
    pry(Pry):1> self
    => Pry
    pry(Pry):1> cd ..
    pry(main)>

The ls command is essentially a unified wrapper to a number of Ruby's introspection mechanisms, including (but not limited to) the following methods: methods, instance\_variables, constants, local\_variables, instance\_methods, class_variables and all the various permutations thereof.

By default typing ls will return a list of just the local and instance variables available in the current context.

* The -M option selects public instance methods (if available).
* The -m option selects public methods.
* The -c option selects constants.
* The -i option select just instance variables.
* The -l option selects just local variables.
* The -s option modifies the -c and -m and -M options to go up the superclass chain (excluding Object).
* The --grep REGEX prunes the list to items that match the regex.

###Source Browsing


Simply typing show-method method_name will pull the source for the method and display it with syntax highlighting. You can also look up the source for multiple methods at the same time, by typing show-method method1 method2. As a convenience, Pry looks up both instance methods and class methods using this syntax, with priority given to instance methods.

    pry(Pry):1> show-method rep

    From: /Users/john/ruby/projects/pry/lib/pry/pry_instance.rb @ line 191:
    Number of lines: 6

    def rep(target=TOPLEVEL_BINDING)
      target = Pry.binding_for(target)
      result = re(target)

      show_result(result) if should_print?
    end
