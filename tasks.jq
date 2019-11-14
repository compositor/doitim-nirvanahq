[
  .entities[]
|
 {
 method: "task.save",
 id: .uuid,
 type: 0,
 state: (if .repeater == null then $state else 9 end),
 parentid:.project,
 name: .title,
 note:.notes,
 startdate:( if .start_at >0 and .repeater == null then .start_at / 1000 | strftime("%Y%m%d")
 else if .start_at >0 then
 if (.start_at / 1000 | strftime("%m%d")) > "1113" then "2019"+(.start_at / 1000 | strftime("%m%d")) else "2020" + (.start_at / 1000 | strftime("%m%d")) end
 else null end end),
 duedate:( if .end_at > 0 then .end_at / 1000 | strftime("%Y%m%d") else null end),
 tags: (
 if .repeater != null then "bday" else
 if .context == "e1c06a00-4081-11e4-8894-51e3df408535"  then "Home" else
 if .context == "e1c2b3f0-4081-11e4-8894-51e3df408535"  then "Computer" else
 if .context == "e1c37740-4081-11e4-8894-51e3df408535"  then "Phone" else
 if .context == "e1c43a90-4081-11e4-8894-51e3df408535"  then "Errands" else
 "" end  end  end  end  end ),

 _tags:  1573763139,
 _type:  1573763139,
 _state: 1573763139,
 _parentid: 1573763139,
 _name: 1573763139,
 _note: 1573763139,
 _startdate: 1573763140,
 _duedate: 1573763140,
 _recurring: 1573763140,

   "recurring": (if .repeater == null then null else
   "{\"paused\":false,\"freq\":\"yearly\",\"interval\":1,\"on\":{\"0\":{\"month\":\""
   + (.start_at / 1000 | strftime("%m"))
   + "\",\"day\":\"day\",\"nth\":\""
   + (.start_at / 1000 | strftime("%d"))
   + "\"}},\"nextdate\":\""
   + if (.start_at / 1000 | strftime("%m%d")) > "1113" then "2019"+(.start_at / 1000 | strftime("%m%d")) else "2020" + (.start_at / 1000 | strftime("%m%d")) end
   + "\",\"hasduedate\":1,\"spawnxdaysbefore\":1}"
   end)

 }
]
