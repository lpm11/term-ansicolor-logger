require("../lib/term/ansicolor/logger");

log = Term::ANSIColor::Logger.new(STDOUT);
log.progname = "sample1";

# decorated logger output
log.debug("decorated logger output:");
log.debug_cyan("debug_cyan");
log.info_green("info_green");
log.warn_magenta("warn_magenta");
log.error_yellow_bold("error_yellow_bold");
log.fatal_red_bold("fatal_red_bold");

# prefix and suffix
log.debug("setting prefix and suffix:");
log.debug_prefix = "  '";
log.debug_suffix = "'";
log.debug("test1");
log.debug("test2");
log.debug("test3");

# automatic decoration
log.debug_decorate(:yellow, :bold);
log.debug("automatic decoration:");
log.debug("this debug message decorated automatically yellow & bold.");
log.debug("prefix & suffix is overwritten, be aware!");

# that's all!
log.debug_decorate();
log.debug("that's all!!");
