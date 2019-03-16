import Foundation

protocol CountryPickerDelegate: class {
	func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountry country: Country)
}
