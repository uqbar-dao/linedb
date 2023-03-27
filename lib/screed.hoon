|%
++  http-response-cards
  |=  [id=@tas hed=response-header:http data=(unit octs)]
  ^-  (list card:agent:gall)
  =/  paths  [/http-response/[id]]~
  :~  [%give %fact paths %http-response-header !>(hed)]
      [%give %fact paths %http-response-data !>(data)]
      [%give %kick paths ~]
  ==
--