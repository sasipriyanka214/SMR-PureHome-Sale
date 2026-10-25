ENVY ANIMATED LOGIN - MERGED BUILD

This build merges the complete Flask application with the animated login design.

What was changed:
- The login page is now full-screen with the ENVY login animation as the page background.
- The supplied login animation is used from static/videos/envy-login.mp4.
- The browser/taskbar area that was visible inside the supplied screen-recording video was cropped out so it does not appear as a small browser-in-browser rectangle.
- The real Flask login form is shown over the animation after the spray/login-reveal point.
- User and Admin use the same login screen. The User/Admin selector changes the Flask POST endpoint between /login and /admin/login.
- Existing authentication/database logic is preserved; login accepts the username field as the account email and also remains compatible with an email field.
- No changes were made to the application's product/order/admin business logic.

Run:
1. Extract the ZIP.
2. Open the app folder in PowerShell.
3. Install requirements if needed: pip install -r requirements.txt
4. Run the same command you normally use for this Flask application (for example: python app.py).
5. Open the local address shown by Flask.

The login animation is muted so browsers allow autoplay. It starts again whenever the login page is loaded/refreshed.
