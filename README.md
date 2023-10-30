# api-first-playground

Example of api-first with maximum value and minimal effort.

## Part 1 - Publishing common API guidelines and re-usable specs

The directory in ./docs is published to https://api-first-playground.projects.meierhost.com and contains:

- [README.md](docs/README.md) - A description of the API guidelines.
- [common-api.yaml](docs/common-api.yaml) - A partial API document containing re-usable API elements.

I've setup a custom DNS domain for the project so that it can be hosted on Github Pages.

```
CNAME api-first-playground.projects.meierhost.com -> astromechza.github.io
```

## Part 2 - Re-using specs

Once this common-api.yaml is uploaded. I'm using it in my spec like:

```
...
      responses:
        "400":
          $ref: 'https://astromechza.github.io/api-first-playground/common-api.yaml#/components/responses/400'
```

At code generation time, this depends on the library. For Golang I'm using `oapi-codegen` and it requires that I've already compiled and built the common-api in another package somewhere. So my makefile includes an initial step to build the models from there:

```
	cd src/common; \
	curl -O -L https://astromechza.github.io/api-first-playground/common-api.yaml; \
	go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.16.2 --config=common-api-codegen.cfg.yaml common-api.yaml
```

And then finally back in the source package I can build the main api spec:

```
	cd src; \
	go run github.com/deepmap/oapi-codegen/cmd/oapi-codegen@v1.16.2 --config=example-api-codegen.cfg.yaml ../specs/example-api.yaml
```

And the imports should all match up.

## Part 3 - Checking resulting specs with OPA

Install OPA CLI from https://github.com/open-policy-agent/opa/releases/tag/v0.58.0. I'm using an OPA ruleset called `spego` from https://github.com/kevinswiber/spego.

And my makefile checks this with

```
cat specs/example-api.yaml | opa eval --format pretty --bundle spego/src -d spego.conf.yaml -I 'data.openapi.main.problems' | tee /dev/stderr | jq -e '[.[] | select(.severity != "warn") ] | length == 0'
```

This ensures that I print out the problems and exit with a non-zero status if there are any non-warnings.
