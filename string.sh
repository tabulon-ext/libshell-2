#!/bin/bash

# echo "MyDirectoryFileLine" | sed -e 's/\([A-Z]\)/-\1/g' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' -e 's/^-//'

fn_camelize(){
	sed -e 's/[_\-]\(.\)/-\1/g' -e 's/\-[aA]/A/g' -e 's/\-[bB]/B/g' -e 's/\-[cC]/C/g' -e 's/\-[dD]/D/g' -e 's/\-[eE]/E/g' -e 's/\-[fF]/F/g' -e 's/\-[gG]/G/g' -e 's/\-[hH]/H/g' -e 's/\-[iI]/I/g' -e 's/\-[jJ]/J/g' -e 's/\-[kK]/K/g' -e 's/\-[lL]/L/g' -e 's/\-[mM]/M/g' -e 's/\-[nN]/N/g' -e 's/\-[oO]/O/g' -e 's/\-[pP]/P/g' -e 's/\-[qQ]/Q/g' -e 's/\-[rR]/R/g' -e 's/\-[sS]/S/g' -e 's/\-[tT]/T/g' -e 's/\-[uU]/U/g' -e 's/\-[vV]/V/g' -e 's/\-[wW]/W/g' -e 's/\-[xX]/X/g' -e 's/\-[yY]/Y/g' -e 's/\-[zZ]/Z/g' -e 's/^-//' <<< $1
}

fn_lower_separeted(){
	echo "$2" | sed -e 's/[_\-]/'$1'/g' -e 's/\([A-Z]\)/'$1'\1/g' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' -e 's/^'$1'//'
}

underscorize(){
	# echo "$1" | sed -e 's/\([A-Z]\)/_\1/g' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' -e 's/^_//'
	if [ $1 ]; then
		fn_lower_separeted '_' $1
	else
		while read data; do
	      	# printf "$data"
			fn_lower_separeted '_' $data
	  	done
	fi
}

hyphenize(){
	# echo "$1" | sed -e 's/\([A-Z]\)/-\1/g' -e 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/' -e 's/^-//'
	if [ $1 ]; then
		fn_lower_separeted '-' $1
	else
		while read data; do
	      	# printf "$data"
			fn_lower_separeted '-' $data
	  	done
	fi
}

camelize(){
	if [ $1 ]; then
		fn_camelize $1
	else
		while read data; do
	      	# printf "$data"
			fn_camelize $data
	  	done
	fi
}

str_parse(){
	BUFFER='';
	for dir in $1/*; do
	  	file=`echo "$dir" | grep -Eo "([^\.\/]+)\." | sed -E "s/\.$//"`;
	  	if [ ! -s $file ]; then
	  		# echo "$file -> $(hyphenize $file) -> $(underscorize $file) -> $(camelize $file)";
	  		fileUnderscorized=`underscorize $file`;
	  		if [ $file != $fileUnderscorized ]; then
	  			echo "# cp $1/$file.ctp $2/$fileUnderscorized.ctp";
	  		fi
	  		BUFFER="$BUFFER \n\t\$routes->connect('/$(hyphenize $file)', ['controller' => 'XXX', 'action' => '$(camelize $file)']);";
	  	fi
	done
	# echo -e $BUFFER >> $3;
	echo -e $BUFFER;
}

str_parse ./php ./php/test ./config/routes.php

# ls ./php | grep -Eo "([^\.\/]+)\." | sed -E "s/\.$//" | camelize;

# underscorize "MyDirectoryFileLine";
# hyphenize "MyDirectoryFileLine"; 
# camelize "my_directory_file_line";
# camelize "my-directory-file-line";