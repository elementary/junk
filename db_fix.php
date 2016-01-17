<?
require_once("db.inc.php");

	// Get PDO Connection
	$dbh = getDatabaseHandle();

	function recurseDirs($root, $dbh)
	{
		$dirHandle = opendir($root);

		while ($file = readdir($dirHandle))
		{
			if (is_dir($root.$file."/") && $file != "." && $file != "..")
			{
				echo "Directory {$file}: <br/>";
				recurseDirs($root.$file."/", $dbh);
			}
			else
			{
				if ($file != "." && $file != "..")
				{
					$sanitized = preg_replace('/\ /', '%20', ($root . $file));
					echo $sanitized . "<br/>";
					$selected = $dbh->query("SELECT * FROM wallpaper_dev WHERE path = \"$sanitized\"");
					var_dump($selected->rowCount());
					$total_shown = 0;
					$total_picked = 0;
					while ($row = $selected->fetch())
					{
						$total_shown += $row['shown'];
						$total_picked += $row['picked'];
						echo "<br/>";
						var_dump($row);
						echo "<br/>";
					}
				//	$dbh->query("INSERT INTO wallpaper_dev (path, shown, picked) VALUES (\"$sanitized\", $total_shown, $total_picked)");
					echo "NEW DATA: shown = $total_shown, picked = $total_picked";
					echo "<br/><br/>";
				}
			}
		}
	}

	$dir = "wallpapers/";
	recurseDirs($dir, $dbh);

?>
