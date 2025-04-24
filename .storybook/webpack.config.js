module.exports = ({ config }) => {
  // Add a specific rule for redux-actions
  config.module.rules.push({
    test: /node_modules\/redux-actions\/dist\/redux-actions.js$/,
    use: [{
      loader: 'babel-loader',
      options: {
        presets: ['@babel/preset-env'],
        plugins: [
          '@babel/plugin-transform-runtime',
          'babel-plugin-transform-import-meta'
        ]
      }
    }]
  });

  return config;
};
