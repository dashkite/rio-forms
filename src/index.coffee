import * as Fn from "@dashkite/joy/function"
import * as K from "@dashkite/katana/sync"

Errors =

  get: Fn.pipe [
    K.read "handle"
    K.poke ( handle ) -> handle.errors ? {}
  ]

  dismiss: Fn.pipe [
    K.read "handle"
    K.poke ( handle ) -> handle.errors = {}
  ]

Error =

  capture: Fn.pipe [
    K.read "handle"
    K.poke ( handle, target ) ->
      if target?
        handle.errors ?= {}
        handle.errors[ target.name ] =
          target: target
          name: target.name
          message: target.validationMessage
  ]

  dismiss: Fn.pipe [
    K.read "handle"
    K.poke ( handle, { target }) ->
      if target? && handle.errors?[ target.name ]?
        delete handle.errors[ target.name ]
  ]

Form =

  prefill: Fn.pipe [
    Errors.get
    K.poke ( errors, data ) ->  { data, errors }
  ]


export { Form, Error, Errors }