import { render, screen } from '@testing-library/react';
import App from './App';

describe('App', () => {
  it('renders the landing page scaffold', async () => {
    render(<App />);

    expect(screen.getByRole('heading', { name: 'Platforma Treningowa' })).toBeInTheDocument();
    expect(await screen.findByTestId('health-status')).toHaveTextContent('UP');
  });
});
