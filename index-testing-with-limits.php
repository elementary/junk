<?
require_once("db.inc.php");

	if($_REQUEST['force']!=''){
		$overlay = $_REQUEST['force'];
	} else {
		$overlay = rand(1, 3);
	}

	// Get PDO Connection To Database
	$dbh = getDatabaseHandle();

	// Query Database To Pull All Of The Wallpapers
	# TODO: Make It Choose From Ones With Less Than Average Number Of Votes.
	$wallpapers = $dbh->query("
		SELECT *
		FROM wallpaper
		WHERE shown < 600
	");

	// Get Two Random IDs
	$id1 = rand(0, $wallpapers->rowCount());
	$id2 = $id1;

	while ($id1 == $id2){
		$id2 = rand(1, $wallpapers->rowCount());
	}
	echo "<!--ID 1: $id1 :: ID 2: $id2-->";

	$wallpapers = $wallpapers->fetchAll(PDO::FETCH_ASSOC);

	// Get Wallpapers From IDs
	$wallpaper1 = $wallpapers[$id1];
	$wallpaper2 = $wallpapers[$id2];

	$wallpaper1_path = $wallpaper1['path'];
	$wallpaper2_path = $wallpaper2['path'];

?>
<html>
	<head>
		<title>Experiment 2 - elementary Labs</title>
		<link rel="stylesheet" href="style.css">
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
		<script src="./jquery.jkey-1.2.js"></script>
		<script>
			$(document).ready(function() {
				var idArray = [];
				$('.photo').each(function() {
					idArray.push($(this).attr('id'));
				});

				$('.photo').click(function() {
					var id = $(this).attr('id');
			//		alert(id);
				///	$.ajax({
				//		type: "POST",
				//		url: "http://labs.elementaryos.org/experiment-2/ajax.php",
				//		data: "choice_id=" + id + "&id1=" + idArray[0] + "&id2=" + idArray[1],
					});
					window.location.href=window.location.href;
				});
			});
			
			$(document).jkey('1, left',function(){
				$("#<?=$id1;?>").click();
			});
			
			$(document).jkey('2, right',function(){
				$("#<?=$id2;?>").click();
			});
			
			$(document).jkey('esc, up',function(){
				window.location.href=window.location.href;
			});
						
		</script>

	</head>
	<body>
		<header>
			<h1>elementary Labs: Experiment 2</h1>
		</header>
		<section>
			<a class="photo" id="<?=$wallpaper1['id'];?>" href="#" title="Choose Image 1" style="background-image:url(<?=$wallpaper1_path;?>);">
				<img src="overlays/<?=$overlay?>.png" />
			</a>
			<a class="photo" id="<?=$wallpaper2['id'];?>" href="#" title="Choose Image 2" style="background-image:url(<?=$wallpaper2_path;?>);">
				<img src="overlays/<?=$overlay?>.png" />
			</a>
			<span class="instructions">
				<p>Choose the image you think looks better.</p>
				<p>You can use the left and right arrow keys to choose the image on the left or right.</p>
				<p>Image not showing up? Click <a href="./" title="Reload">here</a> to reload, or you can hit the up arrow key.</p>
			</span>
		</section>
		<footer>
		</footer>
	</body>
</html>

