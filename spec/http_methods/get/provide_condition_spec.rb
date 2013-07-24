# encoding: utf-8

require 'sinatra'
require 'stringio'
require 'support/rack'


# matches mime_types with dots, hyphens and plus signs
# filters by accept header
# filters by current Content-Type
# allows multiple mime types for accept header
# respects user agent preferences for the content type
# accepts generic types
# prefers concrete over partly generic types
# prefers concrete over fully generic types
# prefers partly generic over fully generic types
# respects quality with generic types
# supplies a default quality of 1.0
# orders types with equal quality by parameter count
# ignores the quality parameter when ordering by parameter count
# properly handles quoted strings in parameters
# accepts both text/javascript and application/javascript for js
# accepts both text/xml and application/xml for xml