using afIoc
using afBedSheet
using afFormBean

class ContactUsPage  {
    @Inject
    HttpRequest httpRequest
    
    @Inject { type=ContactDetails# } 
    FormBean formBean
    
    new make(|This|in) { in(this) }
    
    Text render() {
        Text.fromHtml(
            "<!DOCTYPE html>
             <html>
             <head>
                 <title>FormBean Demo</title>
                 <link rel='stylesheet' href='/styles.css' >
             </head>
             <body>
                 <h2>Contact Us</h2>
                 <span class='requiredNotification'>* Denotes Required Field</span>
             
                 <form class='contactForm' action='/contact' method='POST'>
                     ${ formBean.renderErrors()   }
                     ${ formBean.renderBean(null) }
                     ${ formBean.renderSubmit()   }
                 </form>
             </body>
             </html>")
    }

    Text onContact() {
        // perform server side validation
        // if invalid, re-render the page and show the errors
        if (!formBean.validateForm(httpRequest.body.form))
            return render
        
        // create an instance of our form object
        contactDetails := (ContactDetails) formBean.createBean
        
        echo("Contact made!")
        echo(" - name:    ${contactDetails.name}")
        echo(" - email:   ${contactDetails.email}")
        echo(" - website: ${contactDetails.website}")
        echo(" - message: ${contactDetails.message}")
        
        // display a simple message
        return Text.fromPlain("Thank you ${contactDetails.name}, we'll be in touch.")
    }
}

class ContactDetails {
    @HtmlInput { required=true; placeholder="Fred Bloggs"; attributes="autofocus" }
    Str name

    @HtmlInput { type="email"; required=true; placeholder="fred.bloggs@example.com"; hint="Proper format 'name@something.com'" }
    Uri email

    @HtmlInput { type="url"; required=true; placeholder="http://www.example.com"; hint="Proper format 'http://someaddress.com'" }
    Str website
    
    @HtmlInput { type="textarea"; required=true; attributes="rows='6'"}
    Str message

    new make(|This|in) { in(this) }
	
	@Validate { field=#name }
	static Void validateName(FormField formField) {
		if (formField.formValue == "Trisha")
			formField.errMsg = "Ex-girlfriends not allowed!"
	}
}

// @SubModule only needed because this example is run as a script
@SubModule { modules=[FormBeanModule#] }
const class AppModule {
    @Contribute { serviceType=Routes# }
    Void contributeRoutes(Configuration conf) {
        conf.add(Route(`/`, ContactUsPage#render))
        conf.add(Route(`/contact`, ContactUsPage#onContact, "POST"))
        
        // to save you typing in a stylesheet, we'll just redirect to one I made earlier
        // conf.add(Route(`/styles.css`, `styles.css`.toFile))
        conf.add(Route(`/styles.css`, Redirect.movedTemporarily(`http://static.alienfactory.co.uk/fantom-docs/afFormBean-quickStart.css`)))
    }
}

class Main {
    Int main() {
		BedSheetBuilder("Example_0").startWisp(8089)
    }
}
