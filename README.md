Flatterline.com
===============

A Jekyll & Sinatra joint, running on Heroku.

## Copyright & license

You will be free to make use of plugins and layout code here.

Content and media remains © Flatterline.

License pending (contact us for details).

## Local Development

### Prerequisites

- `rvm`
- `bundle`
- `gsl` (optionally).
	
	If you don’t have `gsl` installed (currently a `brew` install of `1.14`, not `1.15`, is good if you on OS X), then generation will run a bit more slowly, but you _can_ remove or comment it out of the Gemfile.

### Working and

Our `Procfile` means that you just run `foreman start` in this directory
and (almost) everything keeps updating automatically,
and you just browse to
<http://localhost:5000/>.

If you change the Sinatra app (`flatterline.rb`) or install jekyll plugins,
you will need to restart `foreman` and possibly run `jekyll`.

## Deploying

Best practice would seem to be:

1. Stop foreman, if running (Ctrl-C).
2. Manually run `jekyll`.
3. Commit.
4. Deploy to heroku (`git push <remote_that_refers_to_heroku>`)


### Todo

1. Define classes `.left` and `.caption` (used in existing content) and/or change blog imagery to use a newer construct

2. Define `/blog/`.

3. Choose licenses for code & content.