#!/usr/bin/perl
# Author: tckb <chandra.tungathurthi@rwth-aachen.de>
# Script to extract and validate DKIM signatures

# Install SSL dev ibraries: 
# aptitude install libssl-dev
# Install DKIM Verifier module before you run the script
# sudo perl -MCPAN -e "install Mail::DKIM::Verifier"

# Usage: ./verify_dkim_email.pl < raw_email_data.txt > dkim_signatures.text
use Mail::DKIM::Verifier;

# create a verifier object
my $dkim = Mail::DKIM::Verifier->new();

# or read an email and pass it into the verifier, incrementally
while (<stdin>)
{
    # remove local line terminators
    chomp;
    s/\015$//;

    # use SMTP line terminators
    $dkim->PRINT("$_\015\012");
}
$dkim->CLOSE;

my $result = $dkim->result;

print "################### \n";
print "DKIM Signatures found \n";
print "################### \n";

foreach my $signature ($dkim->signatures)
{
    print "[Signature] " ."\n". $signature->as_string . "\n";
    print "[Verification result] " ."\n". $signature->result_detail . "\n";
    print "[Domain] \n";
    if (! defined $signature->domain) {
      print "-NA-\n";
    }else{
      print $signature->domain . "\n";
    }
    print "[Selector] \n";
    if (! defined $signature->selector) {
      print "-NA-\n";
    }else{
      print $signature->selector . "\n";
    }
    print "[DKIM version] \n";
    if (! defined $signature->version) {
      print "-NA-\n";
    }else{
      print $signature->version . "\n";
    }

    print "[Identity] \n";
    if (! defined $signature->identity) {
      print "-NA-\n";
    }else{
      print $signature->identity . "\n";
    }
    print "--------------------------------------------\n";
}

# the alleged author of the email may specify how to handle email
foreach my $policy ($dkim->policies)
{
    die "fraudulent message" if ($policy->apply($dkim) eq "reject");
}

## Sample Output
###################
# DKIM Signatures found
###################
# [Signature]
# DKIM-Signature: <signature>
# [Verification result]
# fail (message has been altered)
# [Domain]
# yahoo.co.jp
# [Selector]
# yj20110701
# [DKIM version]
# 1
# [Identity]
# @yahoo.co.jp
