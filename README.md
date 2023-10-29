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

## Part 3 - Checking resulting specs with OPA

Install OPA CLI from https://github.com/open-policy-agent/opa/releases/tag/v0.58.0.

## Build 

TODO

## Execute policy check

Install OPA CLI from https://github.com/open-policy-agent/opa/releases/tag/v0.58.0.

```
cat specs/example-api.yaml | opa eval --data policy.rego -I 'data'
```
