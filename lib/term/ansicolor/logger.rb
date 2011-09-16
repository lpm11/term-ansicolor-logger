require("logger");
require("term/ansicolor");

module Term
  module ANSIColor
    class Logger < ::Logger
      SEVERITIES = {
        Logger::Severity::DEBUG    => :debug,
        Logger::Severity::INFO     => :info,
        Logger::Severity::WARN     => :warn,
        Logger::Severity::ERROR    => :error,
        Logger::Severity::FATAL    => :fatal,
        Logger::Severity::UNKNOWN  => :unknown,
      };
      SEVERITY_NAMES = SEVERITIES.values;

      attr_accessor :prefix, :suffix;
      SEVERITY_NAMES.each { |severity|
        eval %Q{
          attr_accessor :#{severity}_prefix, :#{severity}_suffix;
        }
      }

      alias_method :base_add, :add;
      alias_method :base_log, :log;
      SEVERITY_NAMES.each { |severity|
        eval %Q{
          alias_method :base_#{severity}, :#{severity};
        }
      }

      COLORS = [
        nil,
        :black,
        :red,
        :green,
        :yellow,
        :blue,
        :magenta,
        :cyan,
        :white,
      ];

      DECORATIONS = [
        nil,
        :bold,
        :dark,
        :italic,
        :underline,
        :underscore,
        :blink,
        :rapid_blink,
        :negative,
        :concealed,
        :strikethrough,
      ];

      def initialize(dst)
        super;
        @prefix = "";
        @suffix = "";
      end

      def add(severity, message = nil, progname = nil)
        if (message.nil? && progname.nil?)
          super(severity, message, progname);
        else
          prefix = eval("(!@#{SEVERITIES[severity]}_prefix.nil?) ? @#{SEVERITIES[severity]}_prefix:@prefix");
          suffix = eval("(!@#{SEVERITIES[severity]}_suffix.nil?) ? @#{SEVERITIES[severity]}_suffix:@suffix");
          if (message.nil?)
            super(severity, message, prefix + progname + suffix);
          else
            super(severity, prefix + message + suffix, progname);
          end
        end
      end
      
      def log(severity, message = nil, progname = nil)
        add(severity, message, progname);
      end

      SEVERITY_NAMES.each { |s|
        eval %Q{
          def #{s}_decorate(*args)
            @#{s}_prefix = args.inject("") { |f,arg| f + eval("Term::ANSIColor::\#{arg}") };
            @#{s}_suffix = Term::ANSIColor::reset;
          end
        }
      }

      SEVERITY_NAMES.each { |s|
        COLORS.each { |c|
          DECORATIONS.each { |d|
            next if (c.nil? && d.nil?);

            f =  s.to_s();
            f += "_#{c}" if (c);
            f += "_#{d}" if (d);
            x =  "";
            x += eval("Term::ANSIColor::#{c}") if (c);
            x += eval("Term::ANSIColor::#{d}") if (d);

            eval %Q{
              def #{f}(message = nil)
                # This method can use prefix/suffix
                #{s}("#{x}" + message + Term::ANSIColor::reset);
              end
            }
          }
        }
      }
    end
  end
end
