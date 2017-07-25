<?php

/**
 * index.php
 * This file redirects any app to an appstream url or the elementary website
 * NOTE: it expects an app RDNN name as $_GET['app'] parameter
 */

// We don't care about the protocol
$url = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
$path = parse_url($url, PHP_URL_PATH);
$app = trim(end(explode('/', $path)));

if ($app == null || $app === '') {
  header('Location: https://elementary.io');
  exit;
}

if (substr($app, -8) !== '.desktop') {
  $app = $app . '.desktop';
}

?>

<!doctype html>
<html>
<head>
  <title>elementary AppCenter</title>

  <link rel="stylesheet" type="text/css" media="all" href="https://fonts.googleapis.com/css?family=Open+Sans:300,400">

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
      font-size: 26px;
      font-weight: 300;
      margin-bottom: 12px;
      margin-top: 12px;
      opacity: 0;
    }

    p {
      color: #555761;
      max-width: 65ch;
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

    section > * {
      -webkit-animation: 750ms ease 1s 1 normal forwards running fade;
              animation: 750ms ease 1s 1 normal forwards running fade;
      opacity: 0;
    }

    section > *:nth-child(2) {
      animation-delay: 1.5s;
    }

    section > *:nth-child(3) {
      animation-delay: 2s;
    }

    .button {
      background-color: #64b9f1;
      background-image: linear-gradient(to bottom, #4ca7e4, #328ecc);
      border: 1px solid #337cac;
      border-radius: 3px;
      box-shadow:
          inset 0 0 0 1px rgba(255, 255, 255, 0.05),
          inset 0 1px 0 0 rgba(255, 255, 255, 0.45),
          inset 0 -1px 0 0 rgba(255, 255, 255, 0.15),
          0 1px 0 0 rgba(255, 255, 255, 0.15);
      color: #fff;
      font-size: 16px;
      line-height: 40px;
      padding: 8px 16px;
      text-decoration: none;
      text-shadow: 0 1px rgba(0, 0, 0, 0.3);
      transition: all 100ms ease-in;
    }

    .button:active {
      border-color: rgba(0, 0, 0, 0.25);
      box-shadow:
        inset 0 0 0 1px rgba(0, 0, 0, 0.05),
        0 1px 0 0 rgba(255, 255, 255, 0.3);
    }

    .is-hidden {
      display: none;
    }
  </style>
</head>
<body>
  <main>
    <img src="/appcenter.png" alt="appcenter"/>

    <section id="elementary" class="is-hidden">
      <h1>Opening AppCenter</h1>
      <p>This app is available in AppCenter, the open, pay-what-you-want app store for elementary OS. You can safely hit back or close this tab.</p>
      <p>Not on elementary OS? <a href="https://elementary.io">Download it here</a>.</p>
    </section>

    <section id="other" class="is-hidden">
      <h1>Get this app on elementary OS</h1>
      <p>This app is available in AppCenter, the open, pay-what-you-want app store for elementary OS. Download elementary OS to use AppCenter and install this app.</p>

      <div>
        <a href="https://elementary.io" class="button">Download elementary OS</a>
      </div>
    </section>
  </main>

  <footer>
    <script>
      var title = document.getElementsByTagName('main')[0]
      var userAgent = navigator.userAgent.toLowerCase()

      var isLinux = (userAgent.indexOf('linux') !== -1 || userAgent.indexOf('elementary') !== -1)
      var isAndroid = (userAgent.indexOf('android') !== -1)

      if (isLinux && isAndroid === false) {
        document.querySelector('#elementary').classList.remove('is-hidden')

        window.location = 'appstream://<?php echo $app ?>'
      } else {
        document.querySelector('#other').classList.remove('is-hidden')
      }
    </script>
  </footer>
</body>
</html>
