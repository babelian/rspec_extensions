def fake_email
  Faker::Internet.email
end

def fake_test_email
  Faker::Internet.user_name + '@test.com'
end

def fake_password
  'password'
end