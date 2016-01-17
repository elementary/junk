<?php
require_once("db.inc.php");

	// Get PDO Connection To Database
	$dbh = getDatabaseHandle();

	// http://stackoverflow.com/questions/2528848/recursion-through-a-directory-tree-in-php
	function recurseDirs($root, $dbh)
	{
		$insert_qry = $dbh->prepare("
			INSERT IGNORE INTO wallpaper (path, shown, picked)
			VALUES ((:path), 0, 0)
		");

		$dirHandle = opendir($root);

		while($file = readdir($dirHandle))
		{
			if(is_dir($root.$file."/") && $file != "." && $file != "..")
			{
				echo "Directory {$file}: <br />";
				recurseDirs($root.$file."/", $dbh);
			}
			else
			{
				if ($file != "." && $file != "..")
				{
					$sanitized = preg_replace('/\ /', '%20', ($root . $file));
					echo $sanitized . "<br/>";
					$qry_array = array(":path" => ($sanitized));
		//			$insert_qry->execute($qry_array);
				}
			}
		}
	}
//	$dir = "/var/www/labs/experiment-2/wallpapers/";
	$dir = "wallpapers/Chrome OS/";
	recurseDirs($dir, $dbh);
?>
