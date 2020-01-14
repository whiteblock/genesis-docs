# Genesis documentation

Welcome to the Genesis documentation!

You can see the live version of our docs at https://docs.whiteblock.io.

Our documentation is open source under MIT license, and you are welcome to fork this repository, edit its contents and submit pull requests.

Your feedback is important to us, so feel free to file [issues](https://github.com/whiteblock/genesis-docs/issues) if you see something out of place or if you have a request for a new element.

# Running locally

You will need Ruby 2.0 or later installed on your computer.

```
$> gem install bundler
$> bundle install
$> bundle exec jekyll serve
```

The output should show the location at which the docs are now served - usually port 4000.

# Docker

We provide a Dockerfile that bundles the contents of this repo, generates the HTML and outputs it into a simple image running nginx.

To build the Docker image, run:

```
$> docker build -t mydocs .
```

To run the Docker image, run:

```
$> docker run mydocs
```

# License

See [LICENSE](LICENSE)
