FactoryGirl.define do
	factory :user do
		sequence(:name) {|n| "Person #{n}" }
		sequence(:email) {|n| "person_#{n}@example.com" }
		password	"starcraft"
		password_confirmation	"starcraft"
	end

	factory :admin do
		admin true
	end
end