This is copy of a repo in Gitcoop:  https://git.coop/decentral1se/es-api
I believe I've copied it under its licensed terms in Gitcoop.
I'm playing around to see how to launch it as an API service for a verb conjugator project.

3/31/19 Notified decentral1se the repo's owner about use.

# es-api: spanish verb conjugation web API
A Spanish verb conjugator web API. This API can be consumed by clients who need
Spanish verb conjugation as a service. Based on the database from
[fred-jehle-spanish-verbs][2], there are 600+ conjugated Spanish verbs. This
provides 11,000+ combinations of mood and tense.

## Contributing
Development is powered by the awesome [stack][5] and [docker][7]. The following
command will build a local image:

    $ docker build -t verbs .

After the image is built, all subsequent ``stack`` commands will use a docker
container under the hood.

You can go ahead and run the following:

    $ stack setup
    $ stack build --test
    $ stack exec es-api

After running ``stack exec``, the API service will be running on ``127.0.0.1:8081``.

[1]: https://travis-ci.org/lwm/es-api
[2]: https://github.com/ghidinelli/fred-jehle-spanish-verbs
[3]: https://hackage.haskell.org/package/postgresql-simple-0.4.10.0
[4]: https://haskell-servant.github.io/
[5]: https://github.com/commercialhaskell/stack
[6]: https://github.com/lwm/es-api/issues/6
[7]: https://www.docker.com/
[8]: https://github.com/lwm/es-api/issues/8
