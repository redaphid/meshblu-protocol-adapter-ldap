_ = require 'lodash'
ldap = require 'ldap'
MeshbluHttp = require 'meshblu-http'
server = ldap.createServer()

server.listen 1389, '0.0.0.0', =>
  console.log "listening"

server.bind '', (req, res, next) =>
  uuid = _.replace req.dn.toString(), 'uid=', ''
  token = req.credentials
  console.log {uuid, token}
  meshblu = new MeshbluHttp {uuid, token}
  meshblu.whoami (error, device) =>
    console.log {error, device}
    return next new ldap.InvalidCredentialsError() if error?.code == 403
    return next new ldap.OperationsError(error.message) if error?
    res.end()
    next()

server.on 'error', (error) =>
  console.log "Got an error. Whaaaaa?", error.messag
