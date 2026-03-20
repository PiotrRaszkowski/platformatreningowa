interface FeatureCardProps {
  title: string;
  description: string;
}

export function FeatureCard({ title, description }: FeatureCardProps) {
  return (
    <div className="card h-100 shadow-sm border-0">
      <div className="card-body">
        <h3 className="h5 card-title">{title}</h3>
        <p className="card-text text-secondary mb-0">{description}</p>
      </div>
    </div>
  );
}
