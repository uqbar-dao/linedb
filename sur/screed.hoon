/-  *linedb
/+  *mip
|%
+$  metadata
  $:  title=@t
      published=@da
      comments=(map @da comment)
      :: global-permissions=permissions
      :: user-permissions=(map @p permissions)
  ==
::
+$  permissions
  $~  %none
  ?(%none %read %comment %write)
::
+$  comment
  $:  =line
      author=@p
      content=@t
  ==
::
+$  action
  $%  [%save-file =path title=@t md=@t] :: should commit and edit metadata
      [%add-comment =path =line content=@t]
      [%delete-comment =path id=@da]
  ==
::
+$  update
  $%  [%post =path title=@t published=@da md=@t]
      [%posts posts=(list [=path title=@t published=@da])]
      [%comments comments=(list [time=@da line=@ud author=@p content=@t])]
  ==
::
++  comment-on  ((on line comment) lth)
--