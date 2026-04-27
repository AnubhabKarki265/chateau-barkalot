// Cloudflare Worker — serves index.html for all requests
export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // Serve index.html for root and any unmatched path
    const html = await env.ASSETS.fetch(
      new Request(new URL("/index.html", request.url)),
    );
    return html;
  },
};
