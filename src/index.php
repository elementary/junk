<?php

/**
 * index.php
 * This file redirects any app to an appstream url or the elementary website
 * NOTE: it expects an app RDNN name as $_GET['app'] parameter
 */

$redirectUrl = 'https://elementary.io';

// We don't care about the protocol
$url = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
$path = parse_url($url, PHP_URL_PATH);
$app = trim(end(explode('/', $path)));

if ($app == null || $app === '') {
  header('Location: '.$redirectUrl);
  exit();
}

if (substr($app, -8) !== '.desktop') {
  $app = $app . '.desktop';
}

if (substr_count($app, '.') < 3) {
  header('Location: '.$redirectUrl);
  exit();
}

?>

<!doctype html>
<html>
<head>
  <title>elementary AppCenter</title>

  <link rel="stylesheet" type="text/css" media="all" href="https://fonts.googleapis.com/css?family=Open+Sans:300">

  <style>
    @-webkit-keyframes fade {
      from {
        opacity: 0;
      }

      to {
        opacity: 1;
      }
    }

    @keyframes fade {
      from {
        opacity: 0;
      }

      to {
        opacity: 1;
      }
    }

    html,
    body {
      color: #333;
      font-family: "Open Sans", Helvetica, sans-serif;
      text-align: center;
      margin: 0;
      padding: 0;
    }

    h1 {
      -webkit-animation: 1s ease 1s 1 normal forwards running fade;
              animation: 1s ease 1s 1 normal forwards running fade;
      font-size: 26px;
      font-weight: 100;
      margin-top: 12px;
      margin-bottom: 12px;
      opacity: 0;
    }

    h3 {
      -webkit-animation: 1s ease 1.5s 1 normal forwards running fade;
              animation: 1s ease 1.5s 1 normal forwards running fade;
      font-size: 18px;
      font-weight: 100;
      margin-top: 0px;
      opacity: 0;
    }

    p {
      -webkit-animation: 1s ease 2s 1 normal forwards running fade;
              animation: 1s ease 2s 1 normal forwards running fade;
      color: #555761;
      opacity: 0;
    }
    
    main {
      -ms-flex-line-pack: center;
          align-content: center;
      -webkit-box-align: center;
          -ms-flex-align: center;
              align-items: center;
      display: -webkit-box;
      display: -ms-flexbox;
      display: flex;
      -webkit-box-orient: vertical;
      -webkit-box-direction: normal;
          -ms-flex-direction: column;
              flex-direction: column;
      height: 100vh;
      -webkit-box-pack: center;
          -ms-flex-pack: center;
              justify-content: center;
      width: 100vw;
    }
  </style>
</head>
<body>
  <main>
    <img src="/appcenter.png" alt="appcenter"/>
  </main>

  <footer>
    <script>
      var title = document.getElementsByTagName('main')[0]
      var userAgent = navigator.userAgent.toLowerCase()
      var isLinux = (userAgent.indexOf('linux') !== -1 || userAgent.indexOf('elementary') !== -1)

      if (isLinux) {
        title.innerHTML += '<h1>Opening AppCenter</h1><h3>You can safely hit back or close this tab.</h3><p>Not on elementary OS? <a href="https://elementary.io">Download it here.</a></p>'
        window.location = 'appstream://<?php echo $app ?>'
      } else {
        title.innerHTML += '<h1>Redirecting to elementary.io</h1>'
        window.location = '<?php echo $redirectUrl ?>'
      }
    </script>
  </footer>
</body>
</html>
