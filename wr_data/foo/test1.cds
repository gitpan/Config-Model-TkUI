#"class comment
big
really big"
std_id#"std_id comment"
std_id:"a b"#"std_id comment"
  X=Av -
std_id:"a b.c"#"std_id comment"
  X=Av -
std_id:ab#"std_id comment"
  Z=Cv
  X=Bv -
std_id:ab2#"std_id comment" -
std_id:ab3#"std_id comment" -
std_id:bc#"std_id comment"
  X=Av -
std_id:dd#"std_id comment" -
std_id:e#"std_id comment" -
lista=a,b,c,d
hash_a:"ti ti"="ti ti value"
hash_a:titi=titi_value
hash_a:toto=toto_value#"index comment"
ordered_hash:z=1
ordered_hash:y=2
ordered_hash:x=3
ordered_hash_of_mandatory:foo=hashfoo
ordered_hash_of_nodes:N1
  X=Av -
ordered_hash_of_nodes:N2
  X=Bv -
olist:0
  X=Av -
olist:1
  X=Bv -
tree_macro=mXY#"big lever here"
warp
  a_string=warpfoo
  a_long_string=longfoo
  another_string=anotherfoo
  warp2
    aa2="foo bar" - -
slave_y
  a_string=slave_y_foo
  a_long_string=sylongfoo
  another_string=sy_anotherfoo -
a_string="toto tata"
a_long_string="a very long string with
embedded return"
a_mandatory_string=foo1
another_mandatory_string=foo2
my_plain_check_list=AA,AC
my_ref_check_list=toto
ordered_checklist=A,G,Z
my_reference=titi -
