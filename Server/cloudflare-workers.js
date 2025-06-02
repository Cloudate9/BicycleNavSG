export default {
  async fetch(request, env, ctx) {
    const cache = caches.default;
    const authDest = "https://www.onemap.gov.sg/api/auth/post/getToken";

    async function fetchAuth(username, pw) {
      let authRes = await fetch(authDest, {
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
        // Need to make authRes mutable to change its Cache Control
        authRes = new Response(authRes.body, authRes);
        const jsonRes = await authRes.clone().json();

        const timeNowSeconds = Math.floor(Date.now() / 1000);
        const maxAge = (jsonRes.expiry_timestamp - timeNowSeconds) > 60 * 60 * 24 ? 60 * 60 * 24 : jsonRes.expiry_timestamp - timeNowSeconds;
        authRes.headers.append("Cache-Control", `s-maxage=${maxAge}`);

        ctx.waitUntil(cache.put(authDest, authRes.clone()));
        return authRes; 
      } else {
        return null;
      }
    }

    // Validate url of final endpoint
    const initUrl = new URL(request.url);
    const apiDest = `https://www.onemap.gov.sg${initUrl.pathname}${initUrl.search}`;
    // We don't want people to use our site to effectively surf the whole of onemap
    if (!apiDest.startsWith("https://www.onemap.gov.sg/api/")) {
      return new Response(null, { status: 404 });
    }


    // Now that we know that the endpoint could be legit, attempt to obtain an auth token
    let auth = await cache.match(authDest); 

    if (auth === undefined) {
      auth = await fetchAuth(env.ONEMAP_USERNAME, env.ONEMAP_PASSWORD);
    }
    // Try to get auth key again
    if (auth === null) {
      auth = await fetchAuth(env.ONEMAP_USERNAME, env.ONEMAP_PASSWORD);
    }
    // If we are still unable to get an auth token, just give up
    if (auth === null) {
      return Response(null, { status: 401 });
    }
    const authJson = await auth.json();
    const authToken = authJson.access_token;


    // Actually hit the final endpoint
    const apiRes = await fetch(apiDest, {
      method: request.method,
      headers: { ...request.headers, "Authorization": authToken, "Content-Type": "application/json" },
    });
    
    if (apiRes.status === 404) {
      return new Response(null, { status: 404 });
    }

    return apiRes;
  }
};
