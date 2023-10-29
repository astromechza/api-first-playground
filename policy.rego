package example

import future.keywords.if
import future.keywords.contains

deny[reason] {
    allowed_keys := {"openapi", "info", "paths", "components"}
    input[key]
    not allowed_keys[key]
    reason = sprintf("%v: unexpected key",[key])
}

deny[reason] {
    not input.openapi == "3.0.0"
    reason = "Must contain openapi: 3.0.0"
}

deny[reason] {
    not input.paths
    reason = "Missing paths value"
}

deny[reason] {
    not is_object(input.paths)
    reason = sprintf("Expected paths to be an object, was %v", [type_name(input.paths)])
}

deny[reason] {
    input.paths[path]
    not is_object(input.paths[path])
    reason = sprintf("%v: Expected each path to be an object, but got %v", [path, type_name(input.paths[key])])
}

deny[reason] {
    allowed_methods := {"get", "post", "patch", "put", "delete"}
    input.paths[path][method]
    not allowed_methods[method]
    reason = sprintf("%v: Expected allowed http method but got %v",[path,method])
}

