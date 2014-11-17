# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
User.create!(:username => 'admin', :email => 'admin@example.com',
            :password => 'password', :password_confirmation => 'password')

if Rails.env == 'development'
  # create two accounts and two labels
  a1 = Account.create!( name: 'Foo 1', username: 'foo1',
            password: 'foobar123', password_confirmation: 'foobar123',
            url: 'http://foo1', comments: 'Comments for Foo #1' )
  a2 = Account.create!( name: 'Foo 2', username: 'foo2',
            password: 'foobar123', password_confirmation: 'foobar123',
            url: 'http://foo2', comments: 'Comments for Foo #2' )
  l1 = Label.create!( name: 'Label 1', description: 'Label #1')
  l2 = Label.create!( name: 'Label 2', description: 'Label #2')
  a1.labels << [ l1, l2 ]
  a2.labels << l2
  # add few comments to each account
  1.upto(3) do |i|
    a1.logs.create!( content: "First account comment #{i}" )
  end
  1.upto(4) do |i|
    a2.logs.create!( content: "Second account comment #{i}" )
  end
end

# vim: set et ts=2 sw=2 et:
