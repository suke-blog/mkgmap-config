use utf8;
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";
while(<>){
s/＆/\&#38;/g;
s/＜/\&#60;/g;
s/〈/\&#60;/g;
s/＞/\&#62;/g;
s/〉/\&#62;/g;
s/“/\&#34;/g;
s/”/\&#34;/g;
s/゛/\&#34;/g;
s/″/\&#34;/g;
s/Â/A/g;
s/Ā/A/g;
s/â/a/g;
s/ā/a/g;
s/Î/I/g;
s/Ī/I/g;
s/î/i/g;
s/ī/i/g;
s/Û/U/g;
s/Ū/U/g;
s/û/u/g;
s/ū/u/g;
s/Ê/E/g;
s/Ē/E/g;
s/ê/e/g;
s/ē/e/g;
s/Ô/O/g;
s/Ō/O/g;
s/ô/o/g;
s/ō/o/g;
s/À/A/g;
s/Á/A/g;
s/Ã/A/g;
s/Ä/A/g;
s/Å/A/g;
s/Æ/AE/g;
s/Ç/C/g;
s/È/E/g;
s/É/E/g;
s/Ë/E/g;
s/Ì/I/g;
s/Í/I/g;
s/Ï/I/g;
s/Ð/D/g;
s/Ñ/N/g;
s/Ò/O/g;
s/Ó/O/g;
s/Õ/O/g;
s/Ö/O/g;
s/Ø/O/g;
s/Ù/U/g;
s/Ú/U/g;
s/Ü/U/g;
s/Ý/Y/g;
s/à/a/g;
s/á/a/g;
s/ã/a/g;
s/ä/a/g;
s/å/a/g;
s/æ/ae/g;
s/ç/c/g;
s/è/e/g;
s/é/e/g;
s/ë/e/g;
s/ì/i/g;
s/í/i/g;
s/ï/i/g;
s/ñ/n/g;
s/ò/o/g;
s/ó/o/g;
s/õ/o/g;
s/ö/o/g;
s/ø/o/g;
s/ù/u/g;
s/ú/u/g;
s/ü/u/g;
s/ý/y/g;
s/ÿ/y/g;
s/Œ/OE/g;
s/œ/oe/g;
s/Ş/S/g;
s/ş/s/g;
s///g;
print $_;
}
