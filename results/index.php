<?php

	// Include The Connection Info
	require_once("../db.inc.php");

	// Get PDO Connection To Database
	$dbh = getDatabaseHandle();

	// Set Up Number Of Items
	$limit = ($_GET['show'] == 'all' ? '' : 'LIMIT 25');
	#$limit = 25;
	# TODO: Support Custom Number Of Items With $_GET Variable

	// Decide If Top Or Worst Listing
	$list = $_GET['list'];
	$order = ($list == 'worst' ? 'ASC' : 'DESC');
	
	// Query Database To Pull Top Or Worst 25 Wallpapers
	$wallpapers = $dbh->query("SELECT * FROM wallpaper ORDER BY (2*(picked)-(shown)) $order $limit");
	# NOTE: Okay, this was fun. Basically this weights them properly now (I think). The more votes they have, the more they're weighted from the median position. The expression was derived from negative votes equaling shown - picked, then plugging that into rating = picked - negative. So we get rating = picked - (shown - picked), which works out to the 2picked - shown that I used.

	// Query Database To Pull Total Shown
	$factoid = $dbh->query("SELECT sum(shown) as total_shown FROM wallpaper");

	// Use Total Shown To Calculate Number Of Comparisons
	$factoid = $factoid->fetch();
	$comparisons = number_format(round($factoid['total_shown'] / 2));

?><html>
	<head>
		<title>Experiment 2 - elementary Labs</title>
		<link href='http://fonts.googleapis.com/css?family=Open+Sans+Condensed:700' rel='stylesheet' type='text/css'>
		<link rel="stylesheet" href="../../styles/style.css">
		<link rel="stylesheet" href="./style.css">
	</head>
	<body>
		<div id="message-container">
			<div id="top-message">
				<div class="cn cn-tl"></div>
				<div class="tb tb-t"></div>
				<div class="cn cn-tr"></div>
				<div class="lr lr-l"></div>
				<div class="bg">
					<div id="info-icon"></div>
					<h1>Experiment 2: The Results are (Not) In!</h1>
					<p>Remember, Experiment 2 is still ongoing, so this section will be constantly changing! However, you can still take a look at the current leaders and stats. Wondering how big our sample size is? So far, there have been <?=$comparisons;?> comparisons made.</p>
					<div class="clearboth"></div>
					<div class="lr lr-r"></div>
					<div class="cn cn-bl"></div>
					<div class="tb tb-b"></div>
					<div class="cn cn-br"></div>
				</div>
			</div>
			<div class="clearboth"></div>
			<div id="main-message">
				<div class="cn cn-tl"></div>
				<div class="tb tb-t"></div>
				<div class="cn cn-tr"></div>
				<div class="lr lr-l"></div>
				<div class="bg">

					<?

						// Setup The Counter
						$wall_rank = 0;

						// Iterate Through The Wallpapers
						while($wallpaper = $wallpapers->fetch()){
							$wall_rank++;

							// Calculate The Percent Preferred
							$wall_percent = number_format( $wallpaper['picked'] / $wallpaper['shown'] * 100, 1 );

							// Setup The Basic Wallpaper Info From DB
							$wall_id = $wallpaper['id'];
							$wall_total = $wallpaper['shown'];
							$wall_plus = 2 * $wallpaper['picked'] - $wall_total;
							$wall_plus = ($wall_plus < 0 ? $wall_plus : '+'.$wall_plus);

							// Determine Wallpaper Name and Author
							$wall_details = explode('/',$wallpaper['path']);
							$wall_filename = explode('.',$wall_details[2]);
							$wall_name = str_replace('_',' ',$wall_filename[0]);
							$wall_author = urldecode($wall_details[1]);
							# TODO: Perhaps Clean This Up?

							// Output The HTML For Each Wallpaper
							
					?>

					<div class="row" id="<?=$wall_id;?>">
						<img class="photo small" src="../<?=$wallpaper['path']?>" />
						<h1><?=$wall_name;?></h1>
						<span class="byline">by <em><?=$wall_author;?></em></span>
						<span class="rank"><?=$wall_rank;?></span>
						<span class="stats"><strong><?=$wall_plus;?></strong> | <?=$wall_percent;?>% Preferred</span>
					</div>
					
					<?
					
						}
						
					?>

					<div class="clearboth"></div>
					<div class="lr lr-r"></div>
					<div class="cn cn-bl"></div>
					<div class="tb tb-b"></div>
					<div class="cn cn-br"></div>
				</div>
			</div>
		</div>
			
		<footer>
		</footer>
	</body>
</html>
	
