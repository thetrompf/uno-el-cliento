<?php
	define('DS', '/');
	define('CLIENT_FOLDER', __DIR__.DS.'cliento');
	define('IMG_INPUT', CLIENT_FOLDER.DS.'img');
	define('CSS_INPUT', CLIENT_FOLDER.DS.'less');
	define('COFFEE_INPUT', CLIENT_FOLDER.DS.'coffee');
	define('TMPL_INPUT', CLIENT_FOLDER.DS.'tmpl');

	define('OUTPUT_FOLDER', __DIR__.DS.'public');
	define('JS_OUTPUT', OUTPUT_FOLDER.DS.'js');
	define('IMG_OUTPUT', OUTPUT_FOLDER.DS.'img');
	define('CSS_OUTPUT', OUTPUT_FOLDER.DS.'css');
	define('TMPL_OUTPUT', OUTPUT_FOLDER.DS.'tmpl');

	function glob_recursive($pattern, $flags = 0)
	{
			$files = glob($pattern, $flags);
			
			foreach (glob(dirname($pattern).'/*', GLOB_ONLYDIR|GLOB_NOSORT) as $dir)
			{
					$files = array_merge($files, glob_recursive($dir.'/'.basename($pattern), $flags));
			}
			
			return $files;
	}

	function copy_files($files ,$input_folder, $output_folder)
	{
		foreach($files as $input_file)
		{
			$relative_file = substr($input_file,(strlen($input_folder)));
			$file_c = explode(DS, $relative_file);
			$file = array_pop($file_c);
			$dir = implode(DS, $file_c);
			@mkdir($output_folder.$dir, 0777, true);
			copy($input_file, $output_folder.$relative_file);
		}
	}

	$pattern = COFFEE_INPUT.DS.'*.js';
	$js_files = glob_recursive($pattern, 0, true);
	// print_r($js_files);
	copy_files($js_files, COFFEE_INPUT, JS_OUTPUT);

	$pattern = IMG_INPUT.DS.'*.*';
	$img_files = glob_recursive($pattern, 0, true);
	// print_r($img_files);
	copy_files($img_files, IMG_INPUT, IMG_OUTPUT);

	$pattern = CSS_INPUT.DS.'*.css';
	$css_files = glob_recursive($pattern, 0, true);
	// print_r($css_files);
	copy_files($css_files, CSS_INPUT, CSS_OUTPUT);

	$pattern = TMPL_INPUT.DS.'*.*';
	$tmpl_files = glob_recursive($pattern, 0, true);
	// print_r($tmpl_files);
	copy_files($tmpl_files, TMPL_INPUT, TMPL_OUTPUT);