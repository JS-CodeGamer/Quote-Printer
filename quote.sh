#! /bin/bash


change_color() {
    if [[ $# -le 0 || $# -ge 4 ]];
    then
        echo "error changing color: no arguments provided";
        return -1;
    elif [[ $# -eq 1 ]];
    then
        local color="\033[$1m";
    elif [[ $# -eq 2 ]];
    then
        local color="\033[$1;$2m";
    elif [[ $# -eq 3 ]];
    then
        local color="\033[1;38;2;";
        color+="$[($1%255+1)];";
        color+="$[($2%255+1)];";
        color+="$[($3%255+1)]m";
    fi;
    echo -en "$color"
}


print_underlined() {
    change_color 4;
    for ((i=0;i<$2;i++));
    do
        echo -n "$1";
    done;
    echo "";
    change_color 24;
}


get_quote(){
    local total_quotes=10030;
    local rand_quote_num=$[ ( $1 % $total_quotes ) + 1 ];
    local quote_link="http://www.quotationspage.com/quote/$rand_quote_num.html";
    quote=$(wget -qO - $quote_link | grep -e "<dt>" -e "</dd>" |
                    awk -F'[<>]' '{
                        if($2 ~ /dt/) { print $3 }
                        else if($4 ~ /b/) {
                            printf "%s %s", "\n\t\t\t\t\t-- ", $7
                        }
                    }'
                );
}


# Variables

# Arguments to the script
args=($@);

# Length Variable
len=80;
# Note: we will ormat the input to len charecters per line
# Length Variable END

# Welcome message Variable
#   Edit it with your name
welcome="";
welcome+="Welcome back Jagteshver!";
left=$[$[$len-${#welcome}]/2];

for ((i=0;i<left/2;i++));
do welcome=" "$welcome" ";
done;

for ((i=0;i<left/2;i++));
do welcome="*"$welcome"*";
done;
# Welcome message Variable END

# Variables END

# START SCRIPT
i=1;
while [ $i -lt 5 ]
do
    get_quote $RANDOM;
    echo "$quote" | grep ERROR > /dev/null;
    if [ $? -eq 0 ];
    then
        get_quote $RANDOM;
        i=`expr $i + 1`;
    else
        break;
    fi;
done;

if [ $? -ne 0 ];
then
    a=`date|cut -c 19`;
    var=(
        "Ever tried. Ever failed. No matter. Try Again. Fail again. Fail better.
                \n\t\t\t\t\t-- Samuel Beckett"
        "Never give up, for that is just the place and time that the tide will turn.
                \n\t\t\t\t\t-- Harriet Beecher Stowe"
        "Our greatest weakness lies in giving up.
                The most certain way to succeed is always to try just one more time.
                \n\t\t\t\t\t-- Thomas A. Edison"
        "Life isn't about getting and having, it's about giving and being.
                \n\t\t\t\t\t-- Kevin Kruse"
        "Strive not to be a success, but rather to be of value.
                \n\t\t\t\t\t-- Albert Einstein"
        "You miss 100% of the shots you don't take.
                \n\t\t\t\t\t-- Wayne Gretzky"
        "People who are unable to motivate themselves must be content with mediocrity,
                no matter how impressive their other talents.
                \n\t\t\t\t\t-- Andrew Carnegie"
        "Design is not just what it looks like and feels like. Design is how it works.
                \n\t\t\t\t\t-- Steve Jobs"
        "Only those who dare to fail greatly can ever achieve greatly.
                \n\t\t\t\t\t-- Robert F. Kennedy"
        "All our dreams can come true, if we have the courage to pursue them.
                \n\t\t\t\t\t-- Walt Disney"
        "Success consists of going from failure to failure without loss of enthusiasm.
                \n\t\t\t\t\t-- Winston Churchill"
        );
    quote="${var[$a]}";
fi;


for i in $args;
do
    if [[ -n $i ]];
    then
        if [[ "$i" -eq "-nc" ]];
        then
            nc=1;
        elif [[ -n $i && "$i" -eq "-nf" ]];
        then
            nf=1;
        fi;
    fi;
done;

if [[ -n $nc ]];
then
    change_color 1 ;
elif [[ -n $nf ]];
then
    :;
else
    change_color $RANDOM $RANDOM $RANDOM ;
fi;

print_underlined " " $len;
echo ""
echo -e "$welcome";
print_underlined " " $len;

echo -en "\n$quote" | sed 's/n()//g;' |
        sed -r '/^\s*[1-9]+/b; s/[\.;:]/.\n/g' |
        sed -r '/^\s*-+/b; s/^\s*(.)/\u\1/g' |
        xargs -0 echo | fmt -$len -s;

print_underlined " " $len;
echo ""

change_color 0;
