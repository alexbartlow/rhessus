= rhessus

Rhessus is a scan manager to hook up your nessus install to a RESTful interface (As through Active Resource) to pull scans from a central server.

By default, you should provide checkout, checkin, and failure methods on the resource. This resource should have a 'targets' method that returns a nessus scan file (IP Ranges, etc)

The Checkout method should provide one scan from the queue for this scanner to fire, and lock that job in an application specific way (such as the requesting IP address)

The Checkin method should accept the 'results' field of the scan being filled with a hash in the form of:

    {:ip => result[2],
      :port => result[3],
      :plugin_id => result[4],
      :severity  => (case result[5] 
      when "Security Note"
        0
      when "Security Warning"
        1
      when "Security Hole"
        2
      end),
      :details => result[6]
    }
    
The failure method should unlock the scan, so another scanner can come by later and pick it up.

= License
Copyright (c) 2009 Alex Bartlow

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


