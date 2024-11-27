module TaxHelper
  PROVINCE_TAX_RATES = {
    'Alberta' => { gst: 0.05, pst: 0.00, hst: 0.00 },
    'British Columbia' => { gst: 0.05, pst: 0.07, hst: 0.00 },
    'Manitoba' => { gst: 0.05, pst: 0.07, hst: 0.00 },
    'New Brunswick' => { gst: 0.00, pst: 0.00, hst: 0.15 },
    'Newfoundland and Labrador' => { gst: 0.00, pst: 0.00, hst: 0.15 },
    'Northwest Territories' => { gst: 0.05, pst: 0.00, hst: 0.00 },
    'Nova Scotia' => { gst: 0.00, pst: 0.00, hst: 0.15 },
    'Nunavut' => { gst: 0.05, pst: 0.00, hst: 0.00 },
    'Ontario' => { gst: 0.00, pst: 0.00, hst: 0.13 },
    'Quebec' => { gst: 0.05, pst: 0.09975, hst: 0.00 },
    'Prince Edward Island' => { gst: 0.00, pst: 0.00, hst: 0.15 },
    'Saskatchewan' => { gst: 0.05, pst: 0.06, hst: 0.00 },
    'Yukon' => { gst: 0.05, pst: 0.00, hst: 0.00 }
  }.freeze

  def self.calculate_tax(subtotal, province)
    rates = PROVINCE_TAX_RATES[province]
    return 0 unless rates # Return 0 if the province isn't found

    gst = subtotal * rates[:gst]
    pst = subtotal * rates[:pst]
    hst = subtotal * rates[:hst]

    gst + pst + hst
  end
end
