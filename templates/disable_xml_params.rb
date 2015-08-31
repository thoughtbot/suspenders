# Don't accept XML as input params
ActionDispatch::ParamsParser::DEFAULT_PARSERS.delete(Mime::XML)
