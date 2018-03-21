function headers() {
    const token = localStorage.getItem('roomToken');
    return {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        Authorization: `Bearer: ${token}`
    };
}

function parseResponse(response) {
    return response.json().then((json) => {
        if (!response.ok) {
            return Promise.reject(json);
        }
        return json;
    });
}

function queryString(params) {
    const query = Object.keys(params)
        .map(k => `${encodeURIComponent(k)}=${encodeURIComponent(params[k])}`)
        .join('&');
    return `${query.length ? '?' : ''}${query}`;
}

export default {
    fetch(url, params = {}) {
        return fetch(`${url}${queryString(params)}`, {
            method: 'GET',
            headers: headers(),
        })
            .then(parseResponse);
    },

    post(url, data) {
        const body = JSON.stringify(data);

        return fetch(`${url}`, {
            method: 'POST',
            headers: headers(),
            body,
        })
            .then(parseResponse);
    },
    put(url, data) {
        const body = JSON.stringify(data);

        return fetch(`${url}`, {
            method: 'PUT',
            headers: headers(),
            body,
        })
            .then(parseResponse);
    },
    destroy(url) {
        return fetch(`${url}`, {
            method: 'DELETE',
            headers: headers()
        })
            .then(parseResponse);
    },
};