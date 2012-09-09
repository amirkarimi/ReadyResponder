require 'test_helper'

class PersonTest < ActiveSupport::TestCase


  test "address state must be equal to 2 characters" do
    person = FactoryGirl.create(:person)
    person.state = "M"
    assert person.invalid?, "state too short"
    person.state = "Mass"
    assert person.invalid?, "state too long"
    person.state = "MA"
    assert person.valid?
  end

  test "division 1 and division 2 must be valid" do
    person = FactoryGirl.create(:person)
    person.division1 = "Command"
    assert person.invalid?, "division2 blank when division1 entered should be invalid"
    person.division1 = ""
    person.division2 = "Command"
    assert person.invalid?, "division1 blank when division2 entered should be invalid"
    person.division1 = "Command"
    assert person.valid?
  end

  test "icsid (badge) should be unique" do
    person1 = FactoryGirl.create(:person, icsid: "509")
    person2 = FactoryGirl.create(:person)
    person2.icsid = "509"
    assert person2.invalid?, " ICSID badge duplicated."
    person2.icsid = "555"
    assert person2.valid?
  end
  
  test "driver is skilled at driving" do
    #From the top
    drivingskill = FactoryGirl.create(:skill, title: "Driving")
    assert_equal 'Driving', drivingskill.title
    
    courseMADL = courses(:MADL)
    courseMADL.skills << drivingskill
    assert courseMADL.skills.include?(drivingskill)
    
    drivingcert = certs(:one)
    drivingcert.course = courseMADL
    assert drivingcert.course.skills.include?(drivingskill)
    
    person = people(:driver)
    assert_equal 'X', person.lastname
    
    person.certs << drivingcert
    assert person.skills.include?(drivingskill)
    assert_equal true, person.skilled?('Driving')
  end
  
  test "driver is not skilled at driving when license expired" do
    drivingskill = FactoryGirl.create(:skill, title: "Driving")
    evoc_course = FactoryGirl.create(:course)
    evoc_course.skills << drivingskill
    
    #cert factory creates the person
    drivingcert = FactoryGirl.create(:cert, course: evoc_course, status: "Expired")
    person = drivingcert.person
    
    assert drivingcert.course.skills.include?(drivingskill)
    #assert person.skills.include?(drivingskill), 'Skills does not include driving !'
    #assert_equal false, person.skilled?('Driving')
  end

  test "driver is not skilled at leeching" do
    #This tests that it is false for a skill that does exist
    drivingskill = skills(:leeching)
    assert_equal 'Leeching', drivingskill.title
    
    person = FactoryGirl.create(:person)    
    assert_equal false, person.skilled?('Leeching')
  end

  test "driver is not skill at barking " do
    #This skill doesn't even exist
    person = people(:driver)
    assert_equal 'X', person.lastname
    
    assert_equal false, person.skilled?('Barking')
  end
  
  test "driver is qualified at policing" do
    #From the top
    policetitle = titles(:police)
    assert_equal 'Police Officer', policetitle.title
    drivingskill = FactoryGirl.create(:skill, title: "Driving")
    assert_equal 'Driving', drivingskill.title
    policetitle.skills << drivingskill
    
    courseMADL = courses(:MADL)
    courseMADL.skills << drivingskill
    assert courseMADL.skills.include?(drivingskill)
    
    drivingcert = certs(:one)
    drivingcert.course = courseMADL
    assert drivingcert.course.skills.include?(drivingskill)
    
    person = people(:driver)
    assert_equal 'X', person.lastname
    
    person.certs << drivingcert
    assert person.skills.include?(drivingskill)
    assert_equal true, person.qualified?('Police Officer')
  end
  
  test "driver is NOT qualified at SAR" do
    #From the top
    title = titles(:sarteam)
    assert_equal 'SAR Team', title.title
    landnavskill = skills(:landnav)
    assert_equal 'Land Navigation', landnavskill.title
    title.skills << landnavskill
    
    drivingskill = FactoryGirl.create(:skill, title: "Driving")
    assert_equal 'Driving', drivingskill.title
    courseMADL = courses(:MADL)
    courseMADL.skills << drivingskill
    assert courseMADL.skills.include?(drivingskill)
    
    drivingcert = certs(:one)
    drivingcert.course = courseMADL
    assert drivingcert.course.skills.include?(drivingskill)
    
    person = people(:driver)
    assert_equal 'X', person.lastname
    
    person.certs << drivingcert
    assert person.skills.include?(drivingskill)
    assert_equal false, person.qualified?('SAR Team')
  end

end
