export default {
  async fetch(request, env) {
    async function getAuth(username, pw) {
      const authRes = await fetch("https://www.onemap.gov.sg/api/auth/post/getToken", {
        method: "POST",
        headers: {
        "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email: username,
          password: pw
        }),
      });
      if (authRes.ok) {
        const jsonRes = await authRes.json();
        return new Response(jsonRes.access_token);
      }
    }
    return await getAuth(env.ONEMAP_USERNAME, env.ONEMAP_PASSWORD);
  }
};
