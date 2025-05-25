.fam T
.nr PS 10p
.nr VS 15p
.ds CH
.
.
.defcolor linecolor rgb 0.6f 0.6f 0.6f
.defcolor headingcolor rgb 0.5f 0.5f 0.5f
.
.
.de heading
.   nf
.   ps 14
.   B "\\$1"
\h'0n'\v'-1.2n'\
\m[headingcolor]\
\l'\\n(.lu\(ul'\
\m[default]
.   ps 10
.   sp -.2
.   fi
..

.ce 2
.ps 18
.B "John F. Smith"
.ps 10
john.fictional.smith@mail.com
.TS
tab(;) nospaces;
l rx.
Main Road 66;
Awesometown, 66788;T{
.I "+12 42 99 666"
T}
Wonderland;T{
.I "https://my-little-page.com"
T}
.TE

.heading "Summary"
.LP
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis 

.heading "Professional Experience"
.TS
tab(;) nospaces;
rW15|lx.
\m[default]2019 - today\m[linecolor];T{
.B "Development Engineer at Creative Pros"
\(en Awesometown, Wonderland
.br
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium 
doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore 
veritatis et quasi architecto beatae vitae dicta sunt explicabo.
.sp .5
T}
\m[default]2010 - 2019\m[linecolor];T{
.B "Professional Expert at Dreamworx"
\(en Somefareaway, Neverland
.br
Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed 
quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.
.sp .5
T}
.TE
\m[default]
.heading "Education"
.TS
tab(;) nospaces;
rW15|lx.
2000 - 2005\m[linecolor];T{
.B "The Great University"
\(en West-town, Wonderland
.br
MSc in Computer Science
.sp .5
T}
\m[default]1995 - 2000\m[linecolor];T{
.B "The Fair University"
\(en East-Town, Wonderland
.br
BSc in Economics
.sp .5
T}
.TE
\m[default]
.heading "Language"
.TS
tab(;) nospaces;
rW15|lx.
English\m[linecolor];T{
\m[default]Professional working proficiency
.br
.sp .2
T}
T{
\m[default]
.B "Spanish"
\m[linecolor]
T};T{
.B
\m[default]Native proficiency
.R
.br
.sp .2
T}
.TE
\m[default]
.heading "Skills"
.TS
tab(;) nospaces;
rW15|lx.
Concepts\m[linecolor];T{
Hacking, Programming, Web development
.br
Economics, Microeconomics, Behavioural economics
.br
.sp .5
T}
\m[default]Prog. Languages\m[linecolor];T{
x86 Assembly, C, Haskell, Python
.sp .5
T}
