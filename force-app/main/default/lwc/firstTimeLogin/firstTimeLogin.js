import { LightningElement, track } from "lwc";
import resetUserPassword from "@salesforce/apex/FirstTimeLoginController.resetUserPassword";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class FirstTimeLogin extends LightningElement {
  @track username = "";
  @track accessCode = "";
  @track newPassword = "";
  @track reenterNewPassword = "";
  @track loginMessage = "";

  handleUsernameChange(event) {
    this.username = event.target.value;
  }

  handleAccessCodeChange(event) {
    this.accessCode = event.target.value;
  }

  handleNewPasswordChange(event) {
    this.newPassword = event.target.value;
  }

  handleReenterNewPasswordChange(event) {
    this.reenterNewPassword = event.target.value;
  }

  handleResetPassword() {
    // Debug statement
    console.log("Reset Password clicked");
    console.log(
      `Username: ${this.username}, Access Code: ${this.accessCode}, New Password: ${this.newPassword}, Re-enter New Password: ${this.reenterNewPassword}`
    );

    if (this.newPassword !== this.reenterNewPassword) {
      this.showToast("Error", "Passwords do not match!", "error");
      this.loginMessage = "Passwords do not match!";
      return;
    }

    resetUserPassword({
      username: this.username,
      accessCode: this.accessCode,
      newPassword: this.newPassword
    })
      .then((result) => {
        console.log("Apex call result:", result);
        if (result === "Success") {
          this.loginMessage = "Password reset successfully!";

          window.location.href =
            "https://eere3-dev-ed.develop.my.site.com/userLogin";
        } else {
          this.loginMessage = result;
        }
      })
      .catch((error) => {
        console.error("Error resetting password:", error);
        this.loginMessage = "Error resetting password. Please try again.";
      });
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant
    });
    this.dispatchEvent(event);
  }
}
