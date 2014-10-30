[![Build Status](https://travis-ci.org/asang/smaran.svg?branch=master)](https://travis-ci.org/asang/smaran) 

# Smaran: RoR based secure personal information management system
Smaran is a [Ruby On Rails](http://rubyonrails.org) Ruby On Rails based secure
password and personal information management system (aka Account Management)
system. Password, Url, Comments and other critical information in encrypted
form inside the database. It also supports following  addition features

* Accounts can be assigned `labels` (similar to gmail labels) - which allows
  you to classify them in one or more groups
* Account editing supports `redo/undo` functionality
* PDF, csv and excel export (single account, all account or all accounts
  belonging to a label) is supported

### Pre-requisites

1. [Rails 4.1](https://github.com/rails/rails/tree/4-1-stable)

1. Smaran uses [Recpatcha](https://www.google.com/recaptcha/admin) to avoid DOS
attacks. You should get your `private` key for your domain and configure it as
`recpatcha_private_key` in `config/config.yml`. Following important `gems` are
also used by Smaran.

1. Important Gems

	* [paperclip](https://github.com/thoughtbot/paperclip) - For attachment support
	* [spreadsheet](https://github.com/zdavatz/spreadsheet) - For csv export functionality
	* [authlogic](https://github.com/binarylogic/authlogic) - Authentication
	* [prawn](https://github.com/prawnpdf/prawn) - For PDF export
	* [attr\_encrypted](https://github.com/attr-encrypted/attr_encrypted) - For encrypting attributes stored in database
	* [paper\_trail](https://github.com/airblade/paper_trail) - For redo/undo functionality

### Installation and usage

After cloning the [repository](https://github.com/asang/smaran), you should edit
following files and make suitable changes.

* `db/seed.rb` - Change values used in following snippet in this file suitably

```
	User.create(:username => 'admin', :email => 'admin@example.com',
				:password => 'password',
				:password_confirmation => 'password')
```

* `config/config.yml`

	* Change strong `master_key` and keep it secure. If you change/lose this key,
	  attributes stored in database cannot be decrypted
	* Change `recaptcha_private_key` to match the one assigned by google for
	  your domain 

* `config/application.rb` - Make sure you change `smtp` settings suitably.
  Using [Google SMTP Service](https://support.google.com/a/answer/176600?hl=en)
  is also possible. You may need to use [Google App specific
  password](https://security.google.com/settings/security/apppasswords) with this service

```
    config.action_mailer.smtp_settings = {
            :address => "<your_smtp_server>" ,
            :port => 25,
            :domain => "example.com" ,
            :authentication => :login,
            :user_name => "you@example.com" ,
            :password => "<password>" ,
            :openssl_verify_mode => 'none'
    }
```

### Core Team

Smaran core team consists of Asang Dani ( [asang](http://github.com/asang) ).

### Other questions

To see what has changed in recent versions of Smaran, see the
[CHANGELOG](https://github.com/asang/smaran/blob/master/CHANGELOG.md).
