<?php
require_once("db.inc.php");
	
	// Get Database Handle
	$dbh = getDatabaseHandle();

	// Get Data From AJAX Call
	$id_choice = $_POST['choice_id'];
	$id1 = $_POST['id1'];
	$id2 = $_POST['id2'];
	
	// Get Existing Count For The Wallpaper
	$current_count = $dbh->query("
		SELECT picked
		FROM wallpaper
		WHERE id = " . $id_choice
	);
	$current_count = $current_count->fetch();
	$current_count = $current_count['picked'];

	// Increment And Commit
	$current_count ++;
	$dbh->exec("
		UPDATE wallpaper
		SET picked = $current_count
		WHERE id = " . $id_choice
	);

	
	// Increment "shown" Column For Wallpapers
	incrementShown($dbh, $id1);
	incrementShown($dbh, $id2);

	// Function For Incrementing
	function incrementShown($dbh, $id)
	{
		$current_count = $dbh->query("
			SELECT shown
			FROM wallpaper
			WHERE id = " . $id
		);
		$current_count = $current_count->fetch();
		$current_count = $current_count['shown'];

		$current_count ++;
		$dbh->exec("
			UPDATE wallpaper
			SET shown = $current_count
			WHERE id = " . $id
		);
	}
?>
