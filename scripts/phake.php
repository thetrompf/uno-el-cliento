<?php
define('DS',             DIRECTORY_SEPARATOR);

define('INPUT_ROOT_FOLDER',  'cliento');
define('OUTPUT_ROOT_FOLDER', 'public');

define('CLIENT_FOLDER',       realpath(__DIR__.DS.'..'.DS.INPUT_ROOT_FOLDER));
define('CSS_INPUT',           CLIENT_FOLDER.DS.'styles');
define('IMG_INPUT',           CLIENT_FOLDER.DS.'images');
define('COFFEE_INPUT',        CLIENT_FOLDER.DS.'scripts');
define('TMPL_INPUT',          CLIENT_FOLDER.DS.'scripts');

define('JS_EXTS',             'js');
define('IMG_EXTS',            'jpg,png,gif,jpeg');
define('CSS_EXTS',            'css,'.IMG_EXTS);
define('TMPL_EXTS',           'html,jshtml,hbs,twig,jade');

define('OUTPUT_FOLDER',       __DIR__.DS.'..'.DS.OUTPUT_ROOT_FOLDER);
define('JS_OUTPUT',           OUTPUT_FOLDER.DS.'scripts');
define('IMG_OUTPUT',          OUTPUT_FOLDER.DS.'images');
define('CSS_OUTPUT',          OUTPUT_FOLDER.DS.'styles');
define('TMPL_OUTPUT',         OUTPUT_FOLDER.DS.'scripts');


/**
 * @var array<string> directories to exclude from the filesystem walk.
 */
$exclude_dirs = array();

/**
 * PHP static client files copy script.
 * Operating as part of a bigger building script.
 * Usually this is called first, before calling the compiling of the dynamic files.
 * Preserves the folder structure, and creates output directories, if they don't exist.
 *
 * @author Brian K. Christensen, Secoya A/S <bkc@secoya.dk>
 * @version 0.1.1a
 * @api
 */
class Phake
{
	/**
	 * Holding the arguments from the command-line, including the script name.
	 * @var array<string> arguments.
	 */
	private $argv;

	/**
	 * Holding the count of arguments given, including the script name.
	 * @var int argument counter.
	 */
	private $argc;

	/**
	 * Commands in the command-line that is valid.
	 * $[0] = command
	 * $[1] = alias
	 * $[2] = description
	 *
	 * @var array<commands> all commands valid to use, including the description.
	 **/
	private $commands = array(
		array('build','bake','    Building the project.'),
		array('clean','nuke','    For clearing the output folder.'),
	);

	/**
	 * Options the commands line understands
	 * $[0] = shorthand
	 * $[1] = option
	 * $[2] = description
	 *
	 * @var array<options> alle options valid to use, including the description.
	 **/
	private $options = array(
		array('-v','--verbose','  For verbose info in the phake script.'),
		array('-q','--quiet','    For no info at all, unless if errors occurs.'),
	);

	/**
	 * Holds which of the options defined above
	 * has been given as arguments.
	 *
	 * @var array<string> $selectedoptions
	 **/
	private $selectedoptions = array();

	/**
	 * Constructor
	 * Collects info from the commmand-line
	 * and calls the command chosen.
	 *
	 * @return error code 0|1|2
	 */
	public function __construct()
	{
		// argv and argc, assigned to instance variables
		$this->argc = $_SERVER['argc'];
		$this->argv = $_SERVER['argv'];

		// print out usage if not enough arguments given.
		if($this->argc < 2) {
			$this->print_usage();
		}

		// The command given in the command line
		// $argv[0] = script name
		// $argv[1] = first argument
		$command = $this->argv[1];

		// slicing the rest of the arguments of.
		// and holds them as selected options.
		$this->selectedoptions = array_slice($this->argv, 2);

		try { // calling the command
			$this->callCommand($command);
		} catch(Exception $e) { // print exception if fails, and exit 1 so the script caller is aware of this faild.
			$this->writeLine($e->getMessage());
			exit(2);
		}
		// exiting correctly.
		exit(0);
	}

	/**
	 * Check if a valid command has been given.
	 *
	 * @param string $cmd
	 * @return void
	 */
	private function callCommand($cmd)
	{
		foreach($this->commands as $command)
		{
			if(in_array($cmd, $command)) {
				// Fixing alias calls; calling the comand
				$this->$command[0]();
				return;
			}
		}

		// printing usage of function, because none valid has been called, exit with error.
		$this->print_usage();
		return;
	}

	/**
	 * Helper for checking if verbose option has been given.
	 *
	 * @return boolean whether if the verbose option is chosen
	 */
	private function isVerbose()
	{
		return static::array_in_array(array('-v', '--verbose'), $this->selectedoptions);
	}

	/**
	 * Helper for checking if quiet mode is proivded.
	 *
	 * @notice Quiet overrules the verbose mode.
	 * @return boolean whether the quiet option is provided.
	 */
	private function isQuiet()
	{
		$cmd = (isset($this->argv[1])) ? $this->argv[1] : null;
		return static::array_in_array(array('-q', '--quiet'), $this->selectedoptions) or in_array($cmd,array('-q','--quiet'));
	}

	/**
	 * Pretty printing the commands and options, helper method.
	 *
	 * @param array<string> $args options or commands as array
	 * @return void printing result.
	 */
	private function pretty_print_args(array $args)
	{
		foreach($args as $arg)
		{
			if(!empty($arg[0])) {
				print "  ".$arg[0].", ";
			} else {
				print "  ";
			}
			print $arg[1].$arg[2]."\n";
		}
	}

	/**
	 * Print the usage of Phake.
	 *
	 * @return exit(1) printing usage of Phake
	 */
	private function print_usage()
	{
		if(!$this->isQuiet())
		{
			print "PHP phake script v 0.1a\n";
			print "Usage: php phake.php command [options]\n";
			print "\n";
			print "Commands:\n";
			print $this->pretty_print_args($this->commands);
			print "\n";
			print "Options:\n";
			print $this->pretty_print_args($this->options);
		}
		exit(1);
	}

	/**
	 * Method to search through the filesystem recursively
	 *
	 * @global array $exclude_dirs spcifies folders that glob_recursive should ignore.
	 * @link http://dk2.php.net/glob
	 * @param globpattern $pattern The pattern specifies what to find, and where to look.
	 * @param int $flags tells glob how to behave
	 * @return array<string> file paths of found files.
	 */
	private function glob_recursive($pattern, $flags = 0)
	{
		global $exclude_dirs;

		$files = glob($pattern, $flags);

		foreach (glob(dirname($pattern).DS.'*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir)
		{
			if(in_array($dir, $exclude_dirs)) {
				break;
			}
			$files = array_merge($files, $this->glob_recursive($dir.DS.basename($pattern), $flags));
		}

		return $files;
	}

	/**
	 * Array search for multiple needles.
	 *
	 * @param array<string> $needles needles to search for in the haystack
	 * @param array<string> $haystack array to search in
	 * @return boolean whether or not any needle was found in the haystack
	 */
	private static function array_in_array(array $needles, array $haystack)
	{
		foreach($needles as $needle)
		{
			if(in_array($needle, $haystack)) {
				return true;
			}
		}
		return false;
	}

	/**
	 * Copy files from input to output folder, preserve the folder structure, from the starting point.
	 *
	 * @param array<string> $files filepath of the files to copy
	 * @param string $input_folder path to input folder.
	 * @param string $output_folder path to output folder.
	 * @return void
	 */
	private function copy_files($files ,$input_folder, $output_folder)
	{
		foreach($files as $input_file)
		{
			// figuring out the folder structure to preserver.
			$relative_file = substr($input_file,(strlen($input_folder)));
			$file_c = explode(DS, $relative_file);
			$file = array_pop($file_c);
			$dir = implode(DS, $file_c);

			// creating output folder, and supress warnings, if the folder already exists.
			@mkdir($output_folder.$dir, 0777, true);
			copy($input_file, $output_folder.$relative_file);

			// logging which file copied from where to where
			$this->log("  ".strstr($input_file, INPUT_ROOT_FOLDER));
			$this->log("  ".strstr($output_folder, OUTPUT_ROOT_FOLDER).$relative_file."\n");
		}
	}

	/**
	 * Printing string if in verbose mode.
	 *
	 * @param string $str string to log
	 * @return void
	 */
	private function log($str)
	{
		if($this->isVerbose()) {
			$this->writeLine($str);
		}
	}

	/**
	 * Printing line if not in quiet mode.
	 *
	 * @param string $str string to print.
	 * @return void printing string.
	 */
	private function writeLine($str)
	{
		if(!$this->isQuiet()) {
			print "  $str\n";
		}
	}

	/**
	 * The main build/copying method
	 * Copying all files of specified types in folders specified.
	 *
	 * @return void
	 */
	private function build()
	{
		// creating output folder if not existing
		@mkdir($pathname = OUTPUT_FOLDER, $mode = 0777, $recursive = true);

		$this->writeLine("Copying javascript files");
		$pattern = COFFEE_INPUT.DS.'*.{'.JS_EXTS.'}';
		$js_files = $this->glob_recursive($pattern, $flag = GLOB_BRACE, true);
		$this->copy_files($js_files, COFFEE_INPUT, JS_OUTPUT);

		$this->writeLine("Copying image files");
		$pattern = IMG_INPUT.DS.'*.{'.IMG_EXTS.'}';
		$img_files = $this->glob_recursive($pattern, $flag = GLOB_BRACE, true);
		$this->copy_files($img_files, IMG_INPUT, IMG_OUTPUT);

		$this->writeLine("Copying css files");
		$pattern = CSS_INPUT.DS.'*.{'.CSS_EXTS.'}';
		$css_files = $this->glob_recursive($pattern, $flag = GLOB_BRACE, true);
		$this->copy_files($css_files, CSS_INPUT, CSS_OUTPUT);

		$this->writeLine("Copying template files");
		$pattern = TMPL_INPUT.DS.'*.{'.TMPL_EXTS.'}';
		$tmpl_files = $this->glob_recursive($pattern, $flag = GLOB_BRACE, true);
		$this->copy_files($tmpl_files, TMPL_INPUT, TMPL_OUTPUT);

		$this->writeLine("Done!");
	}

	/**
	 * Cleaning output folder.
	 *
	 * @return void
	 */
	private function clean()
	{
		$this->writeLine("Nuking the output folder");
		$this->rrmdir(OUTPUT_FOLDER);
		$this->writeLine("Done!");
	}

	/**
	 * Recursivly removing directories and files.
	 *
	 * @param string $dir path to directory to recursively remove all files and subdirectories in, including the directory itself.
	 * @return void
	 */
	private function rrmdir($dir)
	{
		// first remove all files in a directory.
		foreach(glob($dir . '/*') as $file)
		{
			// if file is a directory, recursively remove files within the directory.
			if(is_dir($file))
			{
				$this->rrmdir($file);
			} else {
				$this->log("  Removing file: $file");
				unlink($file);
			}
		}
		$this->log("  Removing directory: $dir\n");

		// remove directory when files are removed.
		if(is_dir($dir))
		{
			rmdir($dir);
		}
	}
}

// Starting script.
new Phake();
