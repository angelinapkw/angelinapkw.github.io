#!/bin/sh
set -e

fontName="Syne"  #must match the name in the font file
fontName2="SyneMono"
fontName3="SyneTactile"
axis="wght"

rm -rf ../fonts
mkdir ../fonts ../fonts/variable ../fonts/ttf ../fonts/otf ../fonts/webfonts

echo ".
GENERATING FONTS
."
fontmake -g $fontName.glyphs -o variable --output-path ../fonts/variable/$fontName[$axis].ttf --filter DecomposeTransformedComponentsFilter -f
fontmake -g $fontName.glyphs -i -o ttf --output-dir ../fonts/ttf/ --filter DecomposeTransformedComponentsFilter -f
fontmake -g $fontName.glyphs -i -o otf --output-dir ../fonts/otf/

fontmake -g $fontName2.glyphs -i -o ttf --output-dir ../fonts/ttf/ --filter DecomposeTransformedComponentsFilter -f
fontmake -g $fontName2.glyphs -i -o otf --output-dir ../fonts/otf/

fontmake -g $fontName3.glyphs -i -o ttf --output-dir ../fonts/ttf/  --filter DecomposeTransformedComponentsFilter -f
fontmake -g $fontName3.glyphs -i -o otf --output-dir ../fonts/otf/

echo ".
POST-PROCESSING VF
."
vfs=$(ls ../fonts/variable/*.ttf)
for vf in $vfs
do
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf
	gftools fix-unwanted-tables --tables MVAR $vf
done
rm ../fonts/variable/*gasp*

gftools gen-stat ../fonts/variable/$fontName[$axis].ttf --axis-order 'wght' --inplace

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls ../fonts/ttf/*.ttf)
echo $ttfs
for ttf in $ttfs
do
	ttfautohint $ttf $ttf.fix
	mv $ttf.fix $ttf
	gftools fix-hinting $ttf
	mv $ttf.fix $ttf
	fonttools ttLib.woff2 compress $ttf
done

mv -f ../fonts/ttf/*.woff2 ../fonts/webfonts/

rm -rf master_ufo/ instance_ufo/

echo ".
COMPLETE!
."
