/-  *screed
|%
++  http-response-cards
  |=  [id=@tas hed=response-header:http data=(unit octs)]
  ^-  (list card:agent:gall)
  =/  paths  [/http-response/[id]]~
  :~  [%give %fact paths %http-response-header !>(hed)]
      [%give %fact paths %http-response-data !>(data)]
      [%give %kick paths ~]
  ==
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =^update
    ^-  json
    ?-    -.update
        %post
      %-  pairs
      :~  path+(path path.update)
          title+[%s title.update]
          published+(sect published.update)
          md+[%s md.update]
      ==
    ::
        %posts
      :-  %a
      %+  turn  posts.update
      |=  [pax=^path author=@p title=@t published=@da]
      %-  pairs
      :~  path+(path:enjs:format pax)
          author+(ship:enjs:format author)
          title+s+title
          published+(sect published)
      ==
    ::
        %comments
      :-  %a
      %+  turn  comments.update
      |=  [time=@da line=@ud author=@p content=@t]
      %-  pairs
      :~  time+(sect time)
          line+n+(scot %ud line)
          author+(ship author)
          content+s+content
      ==
    ==
  --
--