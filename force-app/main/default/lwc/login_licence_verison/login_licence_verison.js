import { LightningElement, track } from "lwc";
import login from "@salesforce/apex/Login_licence_controller.login";

export default class LoginPage extends LightningElement {
  @track username = "";
  @track password = "";
  @track errorMessage = "";

  handleUsernameChange(event) {
    this.username = event.target.value;
  }

  handlePasswordChange(event) {
    this.password = event.target.value;
  }

  async handleLogin() {
    try {
      const result = await login({
        username: this.username,
        password: this.password
      });
      if (result === "SUCCESS") {
        // Redirect to the community home page or another page as needed
        window.location.href = "/s/";
      } else {
        this.errorMessage = result;
      }
    } catch (error) {
      this.errorMessage = error.body.message;
    }
  }
}
