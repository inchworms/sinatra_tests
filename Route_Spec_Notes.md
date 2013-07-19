#404s and sets X-Cascade header when no route satisfies the request
#404s and does not set X-Cascade header when no route satisfies the request and x_cascade has been disabled

#recalculates body length correctly for 404 response

TODO:

#allows using unicode
#it handles encoded slashes correctly
#overrides the content-type in error handlers

#matches empty PATH_INFO to "/" if no route is defined for ""
#matches empty PATH_INFO to "" if a route is defined for ""
#takes multiple definitions of a route
#exposes params with indifferent hash
#merges named params and query string params in params
#supports optional named params like /?:foo?/?:bar?
#supports named captures like %r{/hello/(?<person>[^/?#]+)} on Ruby >= 1.9
#supports optional named captures like %r{/page(?<format>.[^/?#]+)?} on Ruby >= 1.9
#does not concatinate params with the same name
#supports single splat params like /*
#supports mixing multiple splat params like /*/foo/*/*
#supports mixing named and splat params like /:foo/*
#matches a dot ('.') as part of a named param
#matches a literal dot ('.') outside of named params
#literally matches dollar sign in paths
#literally matches plus sign in paths
#does not convert plus sign into space as the value of a named param
#literally matches parens in paths
#supports basic nested params
#exposes nested params with indifferent hash
#exposes params nested within arrays with indifferent hash
#supports arrays within params
#supports deeply nested params
#preserves non-nested params
#matches paths that include spaces encoded with %20
#matches paths that include spaces encoded with +
#matches paths that include ampersands
#URL decodes named parameters and splats
#supports regular expressions
#makes regular expression captures available in params[:captures]
#supports regular expression look-alike routes
#raises a TypeError when pattern is not a String or Regexp
#returns response immediately on halt
#halts with a response tuple
#halts with an array of strings
#sets response.status with halt
#transitions to the next matching route on pass
#transitions to 404 when passed and no subsequent route matches
#transitions to 404 and sets X-Cascade header when passed and no subsequent route matches
#uses optional block passed to pass as route block if no other route is found
#passes when matching condition returns false
#does not pass when matching condition returns nil
#passes to next route when condition calls pass explicitly
#passes to the next route when host_name does not match
#passes to the next route when user_agent does not match
#treats missing user agent like an empty string
#makes captures in user agent pattern available in params[:agent]
#matches mime_types with dots, hyphens and plus signs
#filters by accept header
#filters by current Content-Type
#allows multiple mime types for accept header
#respects user agent preferences for the content type
#accepts generic types
#prefers concrete over partly generic types
#prefers concrete over fully generic types
#prefers partly generic over fully generic types
#respects quality with generic types
#supplies a default quality of 1.0
#orders types with equal quality by parameter count
#ignores the quality parameter when ordering by parameter count
#properly handles quoted strings in parameters
#accepts both text/javascript and application/javascript for js
#accepts both text/xml and application/xml for xml
#passes a single url param as block parameters when one param is specified
#passes multiple params as block parameters when many are specified
#passes regular expression captures as block parameters
#supports mixing multiple splat params like /*/foo/*/* as block parameters
#raises an ArgumentError with block arity > 1 and too many values
#raises an ArgumentError with block param arity > 1 and too few values
#succeeds if no block parameters are specified
#passes all params with block param arity -1 (splat args)
#allows custom route-conditions to be set via route options
#
#if RUBY_VERSION >= '1.9'
#raises an ArgumentError with block param arity 1 and no values
#raises an ArgumentError with block param arity 1 and too many values
#else
#does not raise an ArgumentError with block param arity 1 and no values
#does not raise an ArgumentError with block param arity 1 and too many values
#
#matches routes defined in superclasses
#matches routes in subclasses before superclasses
#adds hostname condition when it is in options
#allows using call to fire another request internally
#plays well with other routing middleware
#returns the route signature
#sets env['sinatra.route'] to the matched route
