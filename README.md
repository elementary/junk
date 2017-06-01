# appstream-redirect

This is a bare bones PHP website that is used to redirect urls from
`appcenter.elementary.io/<app-name>` to `appstream://<app-name>` if they are
running elementary, or `elementary.io` if they are not.

### Running

Serve the `src` directory with PHP. Rewrite any url to `app` GET parameter.
Look at the example `nginx.conf` for more information.
